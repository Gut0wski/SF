<?php

namespace AppBundle\Controller;

use AppBundle\Entity\Messages;
use AppBundle\Form\Letter;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

/**
 * Контроллер сообщений между пользователями
 * @package AppBundle\Controller
 */
class MessagesController extends Controller
{
    /**
     * Вывод списка входящих сообщений
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function inboxAction(Request $request)
    {
        $rows = $this->getDoctrine()
            ->getRepository("AppBundle:Messages")
            ->findBy(['recipient' => $this->getUser()->getId()], ['date' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $rows,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render("@App/messages/inbox.html.twig", compact('list'));
    }

    /**
     * Вывод списка исходящих сообщений
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function outboxAction(Request $request)
    {
        $list = $this->getDoctrine()
            ->getRepository("AppBundle:Messages")
            ->findBy(['sender' => $this->getUser()->getId()], ['date' => 'DESC']);
        $paginator = $this->get('knp_paginator');
        $list = $paginator->paginate(
            $list,
            $request->query->getInt('page', 1),
            $request->query->getInt('limit', $this->container->getParameter('limit_blocks'))
        );
        return $this->render("@App/messages/outbox.html.twig", compact('list'));
    }

    /**
     * Создать новое сообщение
     * @param Request $request
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function letterAction(Request $request)
    {
        $message = new Messages();
        $form = $this->createForm(Letter::class, $message, [
            'user_id' => $this->getUser()->getId()
        ]);
        $form->handleRequest($request);
        if ($form->isSubmitted() && $form->isValid()) {
            $object_sender = $this->getDoctrine()
                ->getRepository("AppBundle:Users")
                ->findOneById($this->getUser()->getId());
            $message->setSender($object_sender);
            $em = $this->getDoctrine()->getManager();
            $em->persist($message);
            $em->flush();
            return $this->redirectToRoute('outbox');
        }
        return $this->render('@App/messages/letter.html.twig', [
            'form' => $form->createView()
        ]);
    }

    /**
     * Вывод сообщения (ajax)
     * @param Request $request
     * @return JsonResponse
     */
    public function readAction(Request $request)
    {
        $id = $request->request->get('id');
        $state = $request->request->get('state');
        $message = $this->getDoctrine()
            ->getRepository("AppBundle:Messages")
            ->findOneById($id);
        $arrData = ['output' => $message->getText()];
        if ($state === '1') {
            $message->setReading(1);
            $em = $this->getDoctrine()->getManager();
            $em->persist($message);
            $em->flush();
        }
        return new JsonResponse($arrData);
    }
}