<?php

namespace AppBundle\Controller;

use AppBundle\Form\Contacts;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * Контроллер контактов правления
 * @package AppBundle\Controller
 */
class ContactsController extends Controller
{
    /**
     * Отображение контактов
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function viewAction()
    {
        $contacts = $this->getDoctrine()
            ->getRepository("AppBundle:Contacts")
            ->findAll();
        return $this->render("@App/contacts/view.html.twig", compact('contacts'));
    }

    /**
     * Редактирование контактов
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction(Request $request)
    {
        $index = $this->getDoctrine()
            ->getRepository("AppBundle:Contacts")
            ->findOneById(1);
        if (!$index) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(Contacts::class, $index);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($index);
            $em->flush();
            return $this->redirectToRoute('contacts');
        }
        return $this->render('@App/contacts/edit.html.twig', [
            'form' => $form->createView()
        ]);
    }
}