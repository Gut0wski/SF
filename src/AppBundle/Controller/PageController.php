<?php

namespace AppBundle\Controller;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Form\Index;

/**
 * Контроллер страниц
 * @package AppBundle\Controller
 */
class PageController extends Controller
{
    /**
     * Отображение главной страницы
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function indexAction()
    {
        $index = $this->getDoctrine()
            ->getRepository("AppBundle:Settings")
            ->findOneByParameter('index');
        return $this->render("@App/page/index.html.twig", compact('index'));
    }

    /**
     * Редактирование главной страницы
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editIndexAction(Request $request)
    {
        $index = $this->getDoctrine()
            ->getRepository("AppBundle:Settings")
            ->findOneByParameter('index');
        if (!$index) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Index::class, $index);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($index);
            $em->flush();
            return $this->redirectToRoute('index');
        }
        return $this->render('@App/page/editIndex.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * Установка активности пользователя
     * @param Request $request
     */
    public function activeAction(Request $request)
    {
        $id = $request->request->get('id');
        $user = $this->getDoctrine()
            ->getRepository("AppBundle:Users")
            ->findOneById($id);
        $user->setDateActive(new \DateTime());
        $em = $this->getDoctrine()->getManager();
        $em->persist($user);
        $em->flush();
    }


    public function errorrAction()
    {
        return $this->render("@App/page/error.html.twig");
    }
}
