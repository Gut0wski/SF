<?php

namespace AppBundle\Controller;

use AppBundle\Entity\News;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use AppBundle\Form\News as NewsForm;
use AppBundle\Extend\Utils\Paginate;

/**
 * Новостной контроллер
 * @package AppBundle\Controller
 */
class NewsController extends Controller
{
    /**
     * Вывод списка новостей
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function listAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:News")
            ->findBy(array(), ['date' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render("@App/news/list.html.twig", compact('list'));
    }

    /**
     * Отображение выбранной новости
     * @param integer $id код новости
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function viewAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:News")
            ->find($id);
        return $this->render("@App/news/view.html.twig", compact('item'));
    }

    /**
     * Создание новости
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function newAction(Request $request)
    {
        $item = new News();
        $form = $this->createForm(NewsForm::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:News")
                    ->findBy(array(), ['date' => 'DESC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('news', compact('page'));
        }
        return $this->render('@App/news/new.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Редактирование новости
     * @param integer $id код новости
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function editAction($id, Request $request)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:News")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $form = $this->createForm(NewsForm::class, $item);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($item);
            $em->flush();
            $page = Paginate::findPageModify(
                $item->getId(),
                $this->getDoctrine()
                    ->getRepository("AppBundle:News")
                    ->findBy(array(), ['date' => 'DESC']),
                $this->container->getParameter('limit_blocks')
            );
            return $this->redirectToRoute('news', compact('page'));
        }
        return $this->render('@App/news/edit.html.twig', [
            'form' => $form->createView(),
            'back' => $request->headers->get('referer')
        ]);
    }

    /**
     * Удаление новости
     * @param integer $id код новости
     * @return \Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($id)
    {
        $item = $this->getDoctrine()
            ->getRepository("AppBundle:News")
            ->find($id);
        if (!$item) {
            throw $this->createAccessDeniedException('У вас нет доступа к этой странице!');
        }
        $pg = $this->getDoctrine()
            ->getRepository("AppBundle:News")
            ->findBy(array(), ['date' => 'DESC']);
        $em = $this->getDoctrine()->getManager();
        $em->remove($item);
        $em->flush();
        $page = Paginate::findPageDelete(
            $pg,
            $this->container->getParameter('limit_blocks')
        );
        return $this->redirectToRoute('news', compact('page'));
    }
}